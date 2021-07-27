# FindMySQL.cmake

if(DEFINED MSVC)
    if(USE_MARIADB)
        find_path(MySQL_INCLUDE_DIR
            NAMES mysql.h
            PATHS "$ENV{ProgramFiles}/mariadb-connector-c/include/mariadb"
                  "$ENV{ProgramFiles(x86)}/mariadb-connector-c/include/mariadb"
            PATH_SUFFIXES include
        )
        find_library(MySQL_LIBRARY
            NAMES libmariadb
            PATHS "$ENV{ProgramFiles}/mariadb-connector-c/lib/mariadb"
                  "$ENV{ProgramFiles(x86)}/mariadb-connector-c/lib/mariadb"
            PATH_SUFFIXES lib
        )
    else()
        find_path(MySQL_INCLUDE_DIR
            NAMES mysql_version.h
            PATHS "$ENV{ProgramFiles}/MySQL/MySQL Server 8.0"
                  "$ENV{ProgramFiles(x86)}/MySQL/MySQL Server 8.0"
            PATH_SUFFIXES include
        )
        find_library(MySQL_LIBRARY
            NAMES mysqlclient
            PATHS "$ENV{ProgramFiles}/MySQL/MySQL Server 8.0"
                  "$ENV{ProgramFiles(x86)}/MySQL/MySQL Server 8.0"
            PATH_SUFFIXES lib
        )
    endif()
else()
    if(USE_MARIADB)
        find_path(MySQL_INCLUDE_DIR
            NAMES mariadb_version.h
            PATH_SUFFIXES mariadb mysql
        )
        find_library(MySQL_LIBRARY NAMES mariadb)
    else()
        find_path(MySQL_INCLUDE_DIR
            NAMES mysql_version.h
            PATH_SUFFIXES mysql
        )
        find_library(MySQL_LIBRARY NAMES mysqlclient mysqlclient_r)
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    MySQL
    MySQL_INCLUDE_DIR
    MySQL_LIBRARY
)

if(MySQL_FOUND AND NOT TARGET MySQL::MySQL)
    # Импортированная библиотека, т.е. не собираемая этой системой сборки.
    # Тип (статическая/динамическая) не известен – может быть любым, смотря что нашлось.
    add_library(MySQL::MySQL UNKNOWN IMPORTED)
    target_include_directories(MySQL::MySQL INTERFACE "${MySQL_INCLUDE_DIR}")
    set_target_properties(MySQL::MySQL PROPERTIES
        # Указать имя файла собранной внешне библиотеки.
        IMPORTED_LOCATION "${MySQL_LIBRARY}"
        # Указать язык библиотеки на случай, когда она статическая.
        IMPORTED_LINK_INTERFACE_LANGUAGES "C")
endif()

mark_as_advanced(MySQL_INCLUDE_DIR MySQL_LIBRARY)
