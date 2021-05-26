#include <chrono>
#include <cstdio>
#include <functional>
#include <memory>
#include <string>

#include "rclcpp/rate.hpp"
#include "rclcpp/rclcpp.hpp"
#include "tf2_ros/static_transform_broadcaster.h"
//#include "geo/msg/TFMessage.hpp"

#include <cstdio>
#include <exception>
#include <geometry_msgs/msg/vector3.h>
#include <rclcpp/rclcpp.hpp>
#include <tf2/LinearMath/Quaternion.h>
#include <tf2_geometry_msgs/tf2_geometry_msgs.h>
#include <tf2_ros/buffer.h>
#include <tf2_ros/static_transform_broadcaster.h>
#include <tf2_ros/transform_broadcaster.h>
#include <tf2_ros/transform_listener.h>

using namespace std::chrono_literals;

/* This example creates a subclass of Node and uses std::bind() to register a
* member function as a callback from the timer. */

class MinimalPublisher : public rclcpp::Node
{
  public:
    MinimalPublisher()
    : Node("minimal_publisher")
    {        
    }

  private:
    
};

std::shared_ptr<MinimalPublisher> node;
std::shared_ptr<tf2_ros::StaticTransformBroadcaster> broad;
std::shared_ptr<tf2_ros::TransformBroadcaster> dynamic_broadcaster;
std::shared_ptr<tf2_ros::TransformListener> listener;
tf2_ros::Buffer *buffer;

#include <geometry_msgs/msg/vector3.h>

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  node = std::make_shared<MinimalPublisher>();
  broad = std::make_shared<tf2_ros::StaticTransformBroadcaster>(node);
  buffer = new tf2_ros::Buffer(node->get_clock());
  listener = std::make_shared<tf2_ros::TransformListener>(*buffer);

  using namespace geometry_msgs;
  msg::Vector3Stamped in;
  in.header.frame_id = "LDS-01_rotated";
  in.vector.x = 1;
  in.vector.y = 0;
  in.vector.z = 0;

  while(true) {
    rclcpp::Rate rate(1);
    rate.sleep();
    printf("HERE\n");
    printf("%d\n", buffer->canTransform("base_link", "LDS-01_rotated", 
                                        tf2::get_now()));
    auto trans = buffer->transform<msg::Vector3Stamped>(in, "base_link");
    printf("%5.2f %5.2f %5.2f\n", 
      trans.vector.x, trans.vector.y, trans.vector.z);
  }

  rclcpp::shutdown();
  return 0;
}