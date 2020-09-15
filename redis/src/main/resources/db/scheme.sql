CREATE TABLE `user` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `name` varchar(64) DEFAULT NULL,
	  `age` int(4) DEFAULT NULL,
	  `user_name` varchar(64) DEFAULT NULL COMMENT '用户名称',
	  `role_id` int(11) DEFAULT NULL COMMENT '用户角色',
	  `date` datetime NULL DEFAULT NULL,
	  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;