pragma Ada_2012;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C.Extensions;

package rclada_tf2_dark_hpp is

   type Point3D is record
      x : aliased double;  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:7
      y : aliased double;  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:7
      z : aliased double;  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:7
   end record
   with Convention => C_Pass_By_Copy;  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:6

  -- Internal node management
   procedure dark_init  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:12
   with Import => True, 
        Convention => CPP, 
        External_Name => "_ZN15rclada_tf2_dark9dark_initEv";

   procedure dark_spin_some  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:14
   with Import => True, 
        Convention => CPP, 
        External_Name => "_ZN15rclada_tf2_dark14dark_spin_someEv";

   procedure dark_shutdown  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:16
   with Import => True, 
        Convention => CPP, 
        External_Name => "_ZN15rclada_tf2_dark13dark_shutdownEv";

  -- Utilities from C++ side
   function dark_can_transform (target : Interfaces.C.Strings.chars_ptr; source : Interfaces.C.Strings.chars_ptr) return Extensions.bool  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:20
   with Import => True, 
        Convention => CPP, 
        External_Name => "_ZN15rclada_tf2_dark18dark_can_transformEPcS0_";

   procedure dark_publish_transform
     (publish_statically : Extensions.bool;
      x : double;
      y : double;
      z : double;
      yaw : double;
      pitch : double;
      roll : double;
      from : Interfaces.C.Strings.chars_ptr;
      to : Interfaces.C.Strings.chars_ptr)  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:22
   with Import => True, 
        Convention => CPP, 
        External_Name => "_ZN15rclada_tf2_dark22dark_publish_transformEbddddddPcS0_";

   function dark_transform
     (point : Point3D;
      target : Interfaces.C.Strings.chars_ptr;
      source : Interfaces.C.Strings.chars_ptr) return Point3D  -- /home/jano/prog/ada4ros2/src/rclada_tf2/gpr_tf2_ros/include/rclada_tf2_dark.hpp:27
   with Import => True, 
        Convention => CPP, 
        External_Name => "_ZN15rclada_tf2_dark14dark_transformENS_7Point3DEPcS1_";

end rclada_tf2_dark_hpp;
