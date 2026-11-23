components {
  id: "goal"
  component: "/main/goal/goal.script"
}
embedded_components {
  id: "model"
  type: "model"
  data: "mesh: \"/builtins/assets/gltf/cube.gltf\"\n"
  "name: \"{{NAME}}\"\n"
  "materials {\n"
  "  name: \"default\"\n"
  "  material: \"/builtins/materials/model_lit.material\"\n"
  "  textures {\n"
  "    sampler: \"tex0\"\n"
  "    texture: \"/main/images/orange_goal_texture.png\"\n"
  "  }\n"
  "}\n"
  ""
  position {
    y: 0.5
  }
}
