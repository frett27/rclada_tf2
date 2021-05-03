#include <rclcpp/rclcpp.hpp>
#include <tf2_ros/static_transform_broadcaster.h>

namespace rclada_tf2_aux {

  //  auto rclada_tf2_aux_node

  class AuxNode : public rclcpp::Node {
    public:
    AuxNode() : Node("RCLAda tf2 aux node") {}
  };


}

extern "C" {

  extern int    gnat_argc;
  extern char **gnat_argv;

  //  Glue to easily call from Ada

  void rclada_tf2_aux_spin() {
    rclcpp::init(gnat_argc, gnat_argv);
    rclcpp::spin(std::make_shared<rclada_tf2_aux::AuxNode>());
    rclcpp::shutdown();
  }

}
