# ZMCalendarPicker
## 使用方法 : 将ZMCalendarPicker文件夹添加到项目当中,直接引用ZMCalendarPicker.h来创建视图即可.

#  包含两种模式，弹出式和正常显示;
#  1.正常显示
    ZMCalendarPicker *picker = [[ZMCalendarPicker alloc] init];
    [self.view addSubview:picker];
    就可以将ZMCalendarPicker添加到你的视图当中
#  2.弹出式
    ZMCalendarPicker *picker = [[ZMCalendarPicker alloc] init];
    [picker showInView:nil andResult:^(NSDate *chooseDate, NSInteger status) {
    }];
    必须通过block的形式进行调用

#  数据返回可使用代理和block，将用户选择的日期和选中日期所属的状态返还;、
#  大部分属性可以自定义;
#  功能独立的界面,使用简单.
#  可以根据需求进行多种状态的设置（必须按要求设置一下两个属性）

    /**
    *  选择模式！！！
    *  数组chooseDateArray包存储着数组B, B数组中存储着一组需要设置相同底色的NSDate
    *  chooseDateArray数量必须与chooseDateColorArray数量相同
    *  数据模式设置错误无效！！！
    */
    @property (nonatomic, strong) NSArray *chooseDateArray;
    /**
    *  选择模式！！！
    *  数组chooseDateColorArray包存UIColor, 用于存储对应chooseDateArray中的底色
    *  chooseDateArray数量必须与chooseDateColorArray数量相同
    *  数据模式设置错误无效！！！
    */
    @property (nonatomic, strong) NSArray *chooseDateColorArray;

#  更多功能请查看demo

