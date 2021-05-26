#include <rclada_tf2_dark.hpp>

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

extern int    gnat_argc;
extern char **gnat_argv;

namespace rclada_tf2_dark {

  rclcpp::Node::SharedPtr node;
  std::shared_ptr<tf2_ros::StaticTransformBroadcaster> static_broadcaster;
  std::shared_ptr<tf2_ros::TransformBroadcaster> dynamic_broadcaster;
  std::shared_ptr<tf2_ros::TransformListener> listener;
  tf2_ros::Buffer *buffer;

  bool dark_can_transform(char *target, char *source) {
    return buffer->canTransform(target, source, tf2::get_now());
  }

  void dark_init() {
    rclcpp::init(gnat_argc, gnat_argv);

    node = rclcpp::Node::make_shared
             ("rclada_tf2_dark_" + std::to_string(std::rand()));

    static_broadcaster =
       std::make_shared<tf2_ros::StaticTransformBroadcaster>(node);
    dynamic_broadcaster =
       std::make_shared<tf2_ros::TransformBroadcaster>(node);

    buffer = new tf2_ros::Buffer(node->get_clock());
    listener =
       std::make_shared<tf2_ros::TransformListener>(*buffer);
  }

  void dark_shutdown() {
    rclcpp::shutdown();
  }

  void dark_publish_transform
    (bool publish_statically,
     double x, double y, double z, double yaw, double pitch, double roll,
     char *from, char *to)
  {
    try {
      geometry_msgs::msg::TransformStamped tf_msg;
      tf2::Quaternion q;

      q.setRPY(roll, pitch, yaw);

      tf_msg.header.stamp = node->now();

      tf_msg.transform.translation.x = x;
      tf_msg.transform.translation.y = y;
      tf_msg.transform.translation.z = z;

      tf_msg.transform.rotation.x = q.x();
      tf_msg.transform.rotation.y = q.y();
      tf_msg.transform.rotation.z = q.z();
      tf_msg.transform.rotation.w = q.w();

      tf_msg.header.frame_id = std::string(from); // Should we copy this?? Let's leak JIC
      tf_msg.child_frame_id = std::string(to); // Should we copy this??

      if (publish_statically)
        static_broadcaster->sendTransform(tf_msg);
      else
        dynamic_broadcaster->sendTransform(tf_msg);

    } catch(std::exception &e) {
      printf("EX: %s\n", e.what());
    }
  }

  Point3D dark_transform(Point3D point, char * target, char * source) {
    using namespace geometry_msgs;
    msg::Vector3Stamped in;
    in.header.frame_id = source;
    in.vector.x = point.x;
    in.vector.y = point.y;
    in.vector.z = point.z;
    msg::Vector3Stamped result =
      buffer->transform<msg::Vector3Stamped> (in, target);
    return { result.vector.x, result.vector.y, result.vector.z };
  }

}
