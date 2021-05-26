cmake_minimum_required(VERSION 3.5)
project(rclada_tf2)

# Default to C99
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 99)
endif()

# Default to C++14
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(geometry_msgs REQUIRED)
find_package(libstatistics_collector REQUIRED) # Needed by the dark side
find_package(rclcpp REQUIRED)
find_package(tf2_geometry_msgs REQUIRED) # Needed by tf2::transform
find_package(tf2_kdl REQUIRED) # Needed by tf2_geometry_msgs
find_package(tf2_msgs REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(rclada_common REQUIRED)
find_package(rosidl_generator_ada REQUIRED)
find_package(rclada REQUIRED)

add_executable(static_pub cpp_tests/static_pub.cpp)
ament_target_dependencies(static_pub 
  rclcpp 
  geometry_msgs 
  tf2_geometry_msgs
  tf2_msgs 
  tf2_ros)
install(TARGETS
  static_pub
  DESTINATION lib/${PROJECT_NAME})

ada_begin_package()

ada_import_c_libraries(${libstatistics_collector_LIBRARIES})
ada_import_c_libraries(${rclcpp_LIBRARIES})
ada_import_c_libraries(${tf2_kdl_LIBRARIES})
ada_import_c_libraries(${tf2_msgs_LIBRARIES})
ada_import_c_libraries(${tf2_ros_LIBRARIES})

file(GLOB
	_headers
	"${CMAKE_SOURCE_DIR}/gpr_tf2_ros/include/*.hpp")

ada_generate_binding(
  rclada_tf2_lib
  gpr_tf2_ros
  tf2_ros.gpr
  gpr_tf2_ros/include
  ${_headers}
)

ada_add_executables(
       rclada_tf2_examples
       gpr_examples
       bin

       dynamic_transform_publisher
       static_transform_publisher
)

add_dependencies(rclada_tf2_examples rclada_tf2_lib)

ada_end_package()
