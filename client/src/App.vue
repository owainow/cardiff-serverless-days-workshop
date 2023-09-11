<template>  
  <vue-progress-bar></vue-progress-bar>
  <ToDoList />
</template>

<script>
import ToDoList from './components/ToDoList.vue'
import { getCurrentInstance } from "vue";

export default {  
  name: 'App',
  components: {
    ToDoList
  },
  setup() {
    const internalInstance = getCurrentInstance();
    //  [App.vue specific] When App.vue is first loaded start the progress bar
    internalInstance.appContext.config.globalProperties.$Progress.start();
    setTimeout(() => {
      internalInstance.appContext.config.globalProperties.$Progress.finish();
    }, 3500);
  }
}
</script>

<style>
  @import url("./styles/todomvc.css");
  @import url("./styles/todo-custom.css");
</style>