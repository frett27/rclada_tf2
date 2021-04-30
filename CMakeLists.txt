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
find_package(rclcpp REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(rclada_common REQUIRED)
find_package(rosidl_generator_ada REQUIRED)
find_package(rclada REQUIRED)

ada_begin_package()

ada_add_executables(
        rclada_tf2_examples
        gpr_tf2_ros
        bin

        static_transform_publisher
)

ada_end_package()
