add_library(sqlpp-mysql
		connection.cpp
		prepared_statement.cpp
		char_result.cpp
		bind_result.cpp
		detail/connection_handle.cpp)

target_include_directories(sqlpp-mysql PUBLIC ${include_dir})
target_link_libraries(sqlpp-mysql PUBLIC PkgConfig::mysql)
target_link_libraries(sqlpp-mysql PUBLIC sqlpp11::sqlpp11)
target_link_libraries(sqlpp-mysql PUBLIC date::date)

install(TARGETS sqlpp-mysql DESTINATION lib)
