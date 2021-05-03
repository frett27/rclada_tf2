package body RCL.TF2 is

   ------------------------------
   -- Publish_Static_Transform --
   ------------------------------

   procedure Publish_Static_Transform
     (From, Into  : String;
      Translation : TF2.Translation;
      Rotation    : TF2.Rotation)
   is
   begin
      raise Program_Error with "unimplemented";
   end Publish_Static_Transform;

   --------------
   -- Aux_Node --
   --------------
   --  This is a C++ side task that for the time being simplifies things for
   --  us. Eventually, we should want to send/receive the transform messages in
   --  our own Ada node. Unfortunately, the tf2_ros C++ API is not written with
   --  simple reuse (i.e. not involving a C++ node) in mind.

   task Aux_Node;

   task body Aux_Node is
      procedure Spin
        with Import,
        Convention => C,
        External_Name => "rclada_tf2_aux_spin";
   begin
      Spin;
   end Aux_Node;

end RCL.TF2;
