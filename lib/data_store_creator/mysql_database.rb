class MysqlDatabase < ActiveRecordDatabase

  def sql_statement(name)
    "CREATE TABLE `#{name}` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `value` float NOT NULL,
    `created_at` datetime NOT NULL,
    `updated_at` datetime NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB"
  end

end