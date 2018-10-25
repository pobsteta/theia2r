.onAttach <- function(libname, pkgname) {
    packageStartupMessage(paste("Welcome to theia2r. To use the package from a GUI, launch", " > theia2r()", "Documentation: https://pobsteta.github.io/theia2r\n", "IMPORTANT: theia2r depends on some external tools;", 
        "before using it, it is strongly recommended to run function", " > check_theia2r_deps()", "to check them and install the missing ones.", sep = "\n"))
}
