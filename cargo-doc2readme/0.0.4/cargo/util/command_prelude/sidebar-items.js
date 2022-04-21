initSidebarItems({"enum":[["AppSettings","Application level settings, which affect how `App` operates"],["CommandInfo",""],["CompileMode","The general “mode” for what to do. This is used for two purposes. The commands themselves pass this in to `compile_ws` to tell it the general execution strategy. This influences the default targets selected. The other use is in the `Unit` struct to indicate what is being done with a specific target."],["ProfileChecking",""]],"fn":[["multi_opt",""],["opt",""],["optinal_opt",""],["optional_multi_opt",""],["subcommand",""],["values",""],["values_os",""]],"struct":[["Arg","The abstract representation of a command line argument. Used to set all the options and relationships that define a valid argument for the program."],["ArgMatches","Used to get information about the arguments that were supplied to the program at runtime by the user. New instances of this struct are obtained by using the `App::get_matches` family of methods."]],"trait":[["AppExt",""],["ArgMatchesExt",""]],"type":[["App",""]]});