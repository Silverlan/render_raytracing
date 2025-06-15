#include <sharedutils/util_library.hpp>
#include <sharedutils/util_path.hpp>
#include <sharedutils/util.h>
#include <sharedutils/util_string.h>
#include <fsys/filesystem.h>
#include <cassert>

int main(int argc, char *argv[])
{
	auto programPath = util::Path::CreatePath(util::get_program_path());
	programPath.PopBack(); // Go up from "bin" directory
	auto strPath = programPath.GetString();
	assert(strPath.length() > 0);
	strPath.pop_back(); // Pop last character (slash)
	util::set_program_path(strPath);

	std::optional<std::string> userDataDir;
	std::vector<std::string> resourceDirs;

	for(size_t i = 0; i < argc; ++i) {
		std::vector<std::string> kv;
		ustring::explode(argv[i], "=", kv);

		if(kv.size() != 2)
			continue;

		if(ustring::compare<std::string>(kv[0], "-user_data_dir", false)) {
			userDataDir = kv[1];
			continue;
		}

		if(ustring::compare<std::string>(kv[0], "-resource_dir", false)) {
			resourceDirs.push_back(kv[1]);
			continue;
		}
	}

	// Initialize file system
	// This should match the behavior in Engine::Initialize
	if(userDataDir)
		filemanager::set_absolute_root_path(*userDataDir, 0);
	else
		filemanager::set_absolute_root_path(util::get_program_path());

	filemanager::set_use_file_index_cache(true);

	if(userDataDir)
		filemanager::add_secondary_absolute_read_only_root_path("core", util::get_program_path());

	size_t resDirIdx = 1;
	for(auto &resourceDir : resourceDirs) {
		filemanager::add_secondary_absolute_read_only_root_path("resource" + std::to_string(resDirIdx), resourceDir, resDirIdx /* priority */);
		++resDirIdx;
	}
	//

	auto path = util::DirPath(FileManager::GetRootPath(), "modules/unirender");

	auto libPath = util::DirPath(FileManager::GetProgramPath());
#ifdef _WIN32
	libPath = util::FilePath(libPath, "bin/render_raytracing_lib");
#else
	libPath = util::FilePath(libPath, "lib/librender_raytracing_lib");
#endif

	// TODO: Use same mount mechanism as core engine
	FileManager::AddCustomMountDirectory("materials");
	std::vector<std::string> addons {};
	FileManager::FindFiles("addons/*", nullptr, &addons);
	for(auto &addon : addons)
		FileManager::AddCustomMountDirectory(("addons/" + addon).c_str());

	std::string err;
	auto lib = util::Library::Load(libPath.GetString(), {path.GetString()}, &err);
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
