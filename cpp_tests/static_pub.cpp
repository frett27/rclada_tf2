#include <chrono>
#include <cstdio>
#include <functional>
#include <memory>
#include <string>

#include "rclcpp/rclcpp.hpp"
#include "tf2_ros/static_transform_broadcaster.h"
//#include "geo/msg/TFMessage.hpp"

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


int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  node = std::make_shared<MinimalPublisher>();
  broad = std::make_shared<tf2_ros::StaticTransformBroadcaster>(node);
  printf("bef\n");

  bool send = false;

  while(true) {
    rclcpp::spin_some(node);

    if (!send) {
        send = true;

        geometry_msgs::msg::TransformStamped msg;

        msg.header.stamp = node->now();

        broad->sendTransform(msg);
        printf("SENT\n");
    }
  }
  printf("aft\n");
  rclcpp::shutdown();
  return 0;
}