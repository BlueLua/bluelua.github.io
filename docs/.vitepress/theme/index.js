import DefaultTheme from "vitepress/theme";
import Layout from "./Layout.vue";
import "virtual:group-icons.css";
import "./style.css";

export default {
  extends: DefaultTheme,
  Layout,
};
