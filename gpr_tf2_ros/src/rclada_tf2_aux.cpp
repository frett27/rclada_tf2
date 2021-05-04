#include <cstdio>
#include <exception>
#include <rclcpp/rclcpp.hpp>
#include <tf2/LinearMath/Quaternion.h>
#include <tf2_ros/static_transform_broadcaster.h>
#include <tf2_ros/transform_broadcaster.h>

namespace rclada_tf2_aux {

  std::shared_ptr<rclcpp::Node> node;
  std::shared_ptr<tf2_ros::StaticTransformBroadcaster> static_broadcaster;
  std::shared_ptr<tf2_ros::TransformBroadcaster> dynamic_broadcaster;


}

//  Glue to easily call from Ada

extern "C" {

  using namespace rclada_tf2_aux;

  extern int    gnat_argc;
  extern char **gnat_argv;

  void rclada_tf2_aux_init() {
    rclcpp::init(gnat_argc, gnat_argv);
    node = std::make_shared<rclcpp::Node>("asdfhaksd"); // TODO: randomize
    static_broadcaster =
      std::make_shared<tf2_ros::StaticTransformBroadcaster>(node);
    dynamic_broadcaster =
 	    std::make_shared<tf2_ros::TransformBroadcaster>(node);
  }

  void rclada_tf2_aux_spin_some() {
    rclcpp::spin_some (node);
  }

  void rclada_tf2_aux_shutdown() {
    rclcpp::shutdown();
  }

  void rclada_tf2_aux_publish_transform
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

}
