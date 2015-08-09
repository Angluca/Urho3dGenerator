> urho3d_generator是一个编译偷懒工具, 如果不想打一大串cmake .. -D... 宏的可以使用, 其它项目也可使用, 此项目没什么技术含量, 纯纯用来练习nim.

## 使用注意事项
- cmakelist.txt里的这行CMake目录必须对准确才会成功, 可以复制.
```cmake
set (CMAKE_MODULE_PATH ${URHO3D_HOME}/./CMake/Modules CACHE PATH "Path to Urho3D-specific CMake modules")
```

- 编译后把CoreData和Data复制到build/bin里

- generator.cfg 来设置, 类似cmake, 把URHO3D_HOME设为Urho3d所在目录, include和lib还有CMake目录都要一起哦.

- nim代码需要使用nimrod编译器编译详情见[nim language](http://nim-lang.org/) 或 [我的博客](http://my.oschina.net/angluca/blog?catalog=3340873)
