#ifndef _rclada_tf2_aux_h
#define _rclada_tf2_aux_h

namespace rclada_tf2_dark {

  struct Point3D {
    double x, y, z;
  };

  // Internal node management

  void dark_init();

  void dark_spin_some();

  void dark_shutdown();

  // Utilities from C++ side

  bool dark_can_transform(char *target, char *source);

  void dark_publish_transform
    (bool publish_statically,
     double x, double y, double z, double yaw, double pitch, double roll,
     char *from, char *to);

  Point3D dark_transform(Point3D point, char *target, char *source);

}

#endif
