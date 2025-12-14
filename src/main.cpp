// SPDX-FileCopyrightText: (c) 2020 Silverlan <opensource@pragma-engine.com>
// SPDX-License-Identifier: MIT

#include <cassert>

#ifdef __linux__
#include <OpenImageDenoise/oidn.h>
void fix_oidn_segfault()
{
	// We need to force-initialize the oidn CUDA context by calling any oidn CUDA function to avoid a segfault later on
	// when cycles tries to use oidn.
	// The reason for this is unknown. For more information, see CMakeLists.txt.
	int n;
	oidnIsCUDADeviceSupported(n);
}
#endif
#include <cstdlib>

import pragma.filesystem;

int main(int argc, char *argv[])
{
	auto programPath = pragma::util::Path::CreatePath(pragma::util::get_program_path());
	programPath.PopBack(); // Go up from "bin" directory
	auto strPath = programPath.GetString();
	assert(strPath.length() > 0);
	strPath.pop_back(); // Pop last character (slash)
	pragma::util::set_program_path(strPath);

	std::optional<std::string> userDataDir;
	std::vector<std::string> resourceDirs;

	for(size_t i = 0; i < argc; ++i) {
		std::vector<std::string> kv;
		pragma::string::explode(argv[i], "=", kv);

		if(kv.size() != 2)
			continue;

		if(pragma::string::compare<std::string>(kv[0], "-user_data_dir", false)) {
			userDataDir = kv[1];
			continue;
		}

		if(pragma::string::compare<std::string>(kv[0], "-resource_dir", false)) {
			resourceDirs.push_back(kv[1]);
			continue;
		}
	}

	// Initialize file system
	// This should match the behavior in Engine::Initialize
	if(userDataDir)
		pragma::fs::set_absolute_root_path(*userDataDir, 0);
	else
		pragma::fs::set_absolute_root_path(pragma::util::get_program_path());

	pragma::fs::set_use_file_index_cache(true);

	if(userDataDir)
		pragma::fs::add_secondary_absolute_read_only_root_path("core", pragma::util::get_program_path());

	size_t resDirIdx = 1;
	for(auto &resourceDir : resourceDirs) {
		pragma::fs::add_secondary_absolute_read_only_root_path("resource" + std::to_string(resDirIdx), resourceDir, resDirIdx /* priority */);
		++resDirIdx;
	}
	//

	auto path = pragma::util::DirPath(pragma::fs::get_root_path(), "modules/unirender");

	auto libPath = pragma::util::DirPath(pragma::fs::get_program_path());
#ifdef _WIN32
	libPath = pragma::util::FilePath(libPath, "bin/render_raytracing_lib");
#else
	libPath = pragma::util::FilePath(libPath, "lib/librender_raytracing_lib");
#endif

	// TODO: Use same mount mechanism as core engine
	pragma::fs::add_custom_mount_directory("materials");
	std::vector<std::string> addons {};
	pragma::fs::find_files("addons/*", nullptr, &addons);
	for(auto &addon : addons)
		pragma::fs::add_custom_mount_directory(("addons/" + addon).c_str());

#ifdef __linux__
	fix_oidn_segfault();
#endif

	std::string err;
	auto lib = pragma::util::Library::Load(libPath.GetString(), {path.GetString()}, &err);
	if(lib == nullptr) {
		std::cout << "Unable to load library '" << libPath.GetString() << "': " << err << std::endl;
		return EXIT_FAILURE;
	}
	auto *f = lib->FindSymbolAddress<int (*)(int, char *[])>("render_raytracing");
	if(f == nullptr) {
		std::cout << "Unable to locate symbol address for 'render_raytracing' in library '" << libPath.GetString() << "'!" << std::endl;
		return EXIT_FAILURE;
	}
	auto result = f(argc, argv);

	// TODO: We'll force an exit, since doing a clean exit causes it to permanently freeze
	// Fix this issue!
	exit(EXIT_SUCCESS);
	lib = nullptr;
	return result;
}
