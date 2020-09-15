find
===
* 注释

	select #use("cols")# from user where #use("condition")#

cols
===

	id,name,age,userName,roleId,date

updateSample
===

	`id`=#id#,`name`=#name#,`age`=#age#,`user_name`=#userName#,`role_id`=#roleId#,`date`=#date#

condition
===

	1 = 1
	@if(!isEmpty(name)){
	 and `name`=#name#
	@}
	@if(!isEmpty(age)){
	 and `age`=#age#
	@}