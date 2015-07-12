import os, parsecfg, strutils, streams
  
when isMainModule:
  const is_console = true

template print(msg:string) =
  if is_console: stdout.writeln(msg)

type
  ProjectData = object
    param: string
    cfg_name:string
    build_dir:string
    build_opt:string
    cd_build_dir:bool

proc newProjectData(): ref ProjectData =
  var obj:ref ProjectData
  new(obj)
  result = obj
  obj.param = ""
  obj.cfg_name = "generator.cfg"
  obj.build_dir = "build"
  obj.build_opt = "cmake"
  obj.cd_build_dir = true

proc readCfgData(self: ref ProjectData): bool=
  var f = newFileStream(self.cfg_name, fmRead)
  if f != nil:
    var p: CfgParser
    open(p, f, self.cfg_name)
    while true:
      var e = next(p)
      case e.kind
      of cfgEof:
        #print("EOF!")
        result = true
        break
      of cfgSectionStart:
        #print("new section: " & e.section)
        discard
      of cfgKeyValuePair:
        #print("key-value-pair: " & e.key & ": " & e.value)
        #if e.key[0] == '#':
          #continue
        case e.key.toLower:
        of "build_dir":
          self.build_dir = e.value
        of "build_opt":
          self.build_opt = e.value
        of "cd_build_dir":
          case e.value.toLower:
          of "true", "1":
            self.cd_build_dir = true
          else:
            self.cd_build_dir = false
        else:
          self.param &= " -D" & e.key & "=" & e.value

      of cfgOption:
        #print("command: " & e.key & ": " & e.value)
        discard
      of cfgError:
        print(e.msg)
    close(p)
  else:
    print("cannot open: " & self.cfg_name)
    result = false


proc makefileGenerate(self: ref ProjectData): bool =
  if self.readCfgData():
    print self.param
  else:
    print "read project.cfg error."
    return false
  let build_path = joinPath(getCurrentDir(), self.build_dir)
  try:
    if not existsDir(build_path):
      createDir(self.build_dir)
      print self.build_dir
    print build_path
    if self.cd_build_dir:
      setCurrentDir(build_path)
    let command = self.build_opt & self.param
    print(command)
    let iret = execShellCmd(command)
    if iret == 0:
      result = true
  except OSError:
    print getCurrentExceptionMsg()
    return false



when isMainModule:
  #if paramCount() < 1:
    #print "Plase input project name."
    #print "./xxx projectname"
    #quit(0)
  #let cmd_name = paramStr(1)
  #let cur_path = getCurrentDir()
   
  #echo "Please input number select mission."
  #echo "1(default): makefile generate."
  #echo "2: Create a project."
  echo "Must have cmake and CMakeLists.txt."


  #var obj = ProjectData(name:cmd_name, cfg_name: "project.cfg", param:"")
  var obj = newProjectData()
  if not obj.makefileGenerate():
    print "failed to generate makefile."

  print "complate."

