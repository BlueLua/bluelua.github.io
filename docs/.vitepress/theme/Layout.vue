<script setup>
import DefaultTheme from "vitepress/theme";
import { useData } from "vitepress";
import { computed } from "vue";

const { Layout } = DefaultTheme;
const { frontmatter, page } = useData();

// Detect if the current page is inside an "api" directory
const isApiPage = computed(() =>
  page.value.relativePath.split("/").includes("api"),
);
</script>

<template>
  <Layout>
    <template #doc-before>
      <div v-if="frontmatter.title" class="vp-doc">
        <h1>
          <!-- Wrap in <code> if inside the api directory -->
          <code v-if="isApiPage">{{ frontmatter.title }}</code>
          <template v-else>{{ frontmatter.title }}</template>
        </h1>
      </div>
    </template>
  </Layout>
</template>
