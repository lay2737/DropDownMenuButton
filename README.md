# DropDownMenuButton
下拉菜单按钮

1.基于UIButton封装的一个下拉菜单按钮

2.需在initWithFrame: fromView:构造方法下创建，fromView: 为按钮的superview，关系到下拉菜单的出现位置

3.可选单列表或双列表

4.菜单数据源直接赋给 mainTableDataArray 和 supportTableDataArray 两个属性，分别代表主、副列表的数据

5.可通过代理定制cell，也可通过属性替换下拉菜单的tableView
