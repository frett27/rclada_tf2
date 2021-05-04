with C_Strings;
with GNAT.Ctrl_C;
with Interfaces.C; use Interfaces;

package body RCL.TF2 is

   ------------------------------
   -- Publish_Static_Transform --
   ------------------------------

   procedure Publish_Static_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Rotation)
   is
      procedure Dark_Publish (X, Y, Z, Yaw, Pitch, Roll : ROSIDL.Types.Float64;
                              From, To                  : C.Strings.chars_ptr)
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_publish_static_transform";
   begin
      Dark_Publish (Translation.X, Translation.Y, Translation.Z,
                    Rotation.Yaw, Rotation.Pitch, Rotation.Roll,
                    C_Strings.To_C (From).To_Ptr,
                    C_Strings.To_C (Into).To_Ptr);
   end Publish_Static_Transform;

   --------------
   -- Shutdown --
   --------------

   Shutdown_Requested : Boolean := False;

   procedure Shutdown is
   begin
      Shutdown_Requested := True;
   end Shutdown;

   --------------
   -- Aux_Node --
   --------------
   --  This is a C++ side task that for the time being simplifies things for
   --  us. Eventually, we should want to send/receive the transform messages in
   --  our own Ada node. Unfortunately, the tf2_ros C++ API is not written with
   --  simple reuse (i.e. not involving a C++ node) in mind.

   task Aux_Node;

   task body Aux_Node is
      procedure Dark_Init
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_init";
      procedure Dark_Spin
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_spin_some";
      procedure Dark_Shutdown
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_shutdown";
   begin
      Dark_Init;

      --  Must be installed after rclcpp installs theirs, or ours is ignored
      GNAT.Ctrl_C.Install_Handler (Shutdown'Access);

      while not Shutdown_Requested loop
         Dark_Spin;
      end loop;
      Dark_Shutdown;
   end Aux_Node;

end RCL.TF2;
