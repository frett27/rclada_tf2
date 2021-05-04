with C_Strings;
with GNAT.Ctrl_C;
with Interfaces.C.Extensions; use Interfaces;

package body RCL.TF2 is

   task Dark_Node is

      entry Publish_Static_Transform
        (From, Into  : String;
         Translation : TF2.Translation;
         Rotation    : TF2.Rotation;
         Static      : Boolean);

   end Dark_Node;

   --------------
   -- Shutdown --
   --------------

   Shutdown_Requested : Boolean := False;

   procedure Shutdown is
   begin
      Shutdown_Requested := True;
   end Shutdown;

   -----------------------
   -- Publish_Transform --
   -----------------------

   procedure Publish_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Rotation;
      Static      : Boolean := False)
   is
   begin
      if Shutdown_Requested then
         return;
      end if;

      Dark_Node.Publish_Static_Transform
        (From, Into, Translation, Rotation, Static);
   end Publish_Transform;

   --------------
   -- Aux_Node --
   --------------
   --  This is a C++ side task that for the time being simplifies things for
   --  us. Eventually, we should want to send/receive the transform messages in
   --  our own Ada node. Unfortunately, the tf2_ros C++ API is not written with
   --  simple reuse (i.e. not involving a C++ node) in mind.

   task body Dark_Node is

      procedure Dark_Init
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_init";
      procedure Dark_Publish (Static                    : C.Extensions.bool;
                              X, Y, Z, Yaw, Pitch, Roll : ROSIDL.Types.Float64;
                              From, To                  : C.Strings.chars_ptr)
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_publish_transform";
      procedure Dark_Spin_Some
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
         select
            accept Publish_Static_Transform
              (From        : String;
               Into        : String;
               Translation : TF2.Translation;
               Rotation    : TF2.Rotation;
               Static      : Boolean)
            do
               Dark_Publish
                 (C.Extensions.bool (Static),
                  Translation.X, Translation.Y, Translation.Z,
                  Rotation.Yaw, Rotation.Pitch, Rotation.Roll,
                  C_Strings.To_C (From).To_Ptr, C_Strings.To_C (Into).To_Ptr);
            end Publish_Static_Transform;
         else
            Dark_Spin_Some;
            delay 0.001; -- Is there really no better solution?
         end select;
      end loop;

      Dark_Shutdown;
   end Dark_Node;

end RCL.TF2;
