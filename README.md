# NJUHelper

南京大学同学们的小助手

# 预览

<table>
    <tr>
        <td><img src="https://github.com/songkuixi/NJUHelper/blob/master/ScreenShots/iPhone_1.png"></td>
        <td><img src="https://github.com/songkuixi/NJUHelper/blob/master/ScreenShots/iPhone_2.png"></td>
        <td><img src="https://github.com/songkuixi/NJUHelper/blob/master/ScreenShots/iPhone_3.png"></td>
        <td><img src="https://github.com/songkuixi/NJUHelper/blob/master/ScreenShots/iPhone_4.png"></td>
        <td><img src="https://github.com/songkuixi/NJUHelper/blob/master/ScreenShots/iPhone_5.png"></td>
    </tr>
</table>

# 功能

|  | 功能 | 贡献者 |
|:-:|:--|:-:|
| ✅ | 校园网登录/登出，包括 3D Touch 快捷功能 | |
| ✅ | 教务网成绩、GPA 查询 | |
| ✅ | 常用网站链接 | |
| TODO | 课表 | |
| TODO | 体育打卡查询 | |

# 说明

#### 如果你是一名 Organization 成员并且需要新增功能

1. 打开`NJUHelper.xcworkspace`，为你的模块新建一个文件夹，放在如下位置。
模块内部的文件结构依个人喜好决定。
    
    ```
    .
    ├── AppDelegate.swift
    ├── Assets.xcassets
    ├── Base.lproj
    ├── Constants.swift
    ├── Info.plist
    ├── NJUHelper-Bridging-Header.h
    ├── UIColorExtensions.swift
    └── <--- 把你的模块（文件夹）新增在这里
    ```
2. 在`UIColorExtensions.swift`中新增你的模块的主题色：

    ```
    static var 你的主题名字: UIColor {
        return 一个 UIColor
    }
    ```

3. 在`MainCollectionViewController.swift`中新增你的模块信息：

    ```
    private let cellColors = [..., UIColor.你的主题名字]
    private let cellTitles = [..., "你的主题名字"]
    private let cellSegues = [..., "你的主题名字Segue"]
    ```
    
4. 在`Main.storyboard`中，拖入你的 VC 或者 Storyboard 引用。然后从`MainCollectionViewController`中拖一个 Segue 到你新增的内容上，注意 Segue 的名称与第 3 步中添加的名称要对应。

#### 如果你不是一名 Organization 成员并且想要贡献代码

请按上述要求新增模块，但请不要随意修改/删除模块。然后请发起 PR，我们会审核后决定是否合并。

# 贡献者



# 协议

__GNU General Public License v3.0__


