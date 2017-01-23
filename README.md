#打个借条开发文档

##一、文件夹

* Appdelegate<br>
存放Appdelegate文件，禁止添加其他文件。

* Base.Iproj<br>
存放系统storyboard，禁止添加其他文件。所有页面由代码生成，不使用storyboard开发。

* Category<br>
扩展，按照所属Object命名文件夹统一存放。

* Components<br>
模块组件，所有页面均存放在此处，按照功能命名文件夹统一存放。(风格尽量统一)<br>
<pre><code>Cell&View      存放Cell、View
Controller     存放Controller
Model          存放模型
Request        存放请求
Reform         存放解析
</code></pre>

* Foundation<br>
底层组件(谨慎修改)<br>

* Helper<br>
辅助类<br>

* Manager<br>
数据管理器<br>

* Resource<br>
资源文件夹<br>

* Supporting File<br>
plist、entitlements文件夹<br>

* Vendors<br>
第三方控件<br>

##二、底层组件
    DJViewController        //ViewController统一继承
    DJTableViewController   //TableViewController统一继承
    WebViewController       //Web统一入口

##三、命名规则
尽量避免拼音形式的命名，并按照模块和功能、类型命名,现项目中多使用驼峰命名
###1、常量命名：
####宏定义
#####作用域+功能
<pre><code>#define DJTableView_HeaderHeight 12                      //通用Header高度
</code></pre>
####类型常量
#####处于编译单元内使用的常量 k+作用域+功能
<pre><code>static const CGFloat kTableViewHeaderHeight              //Header高度
</code></pre>
#####可外部使用的常量 所属模块+作用域+功能
<pre><code>HJLoginViewController.h
    extern const CGFloat HJLoginViewControllerTableViewHeaderHeight //Header高度
</code></pre>
<pre><code>HJLoginViewController.m
    const CGFloat HJLoginViewControllerTableViewHeaderHeight        //Header高度
</code></pre>
###2、枚举
定义typedef NS_ENUM 或 typedef NS_OPTIONS宏。服务端数据做映射匹配，或者特殊（字符串比对）匹配。
<pre><code>typedef NS_ENUM(NSInteger, UITableViewStyle) {
    UITableViewStylePlain,
    UITableViewStyleGrouped,
};
</code></pre>
###3、变量
驼峰命名，功能+类型 EXAMPLE:@property (nonatomic, strong) NSString *titleLabel;  //标题UILabel控件
###4、方法名
驼峰命名，

