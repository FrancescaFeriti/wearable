import 'package:floor/floor.dart';
import 'package:flow1_prova/database/entities/P_access.dart';

@Entity(tableName:'Alcool', primaryKeys: ['id','day','hour','type','quantity', 'percentage'],foreignKeys:[ForeignKey(childColumns: ['id'], parentColumns: ['id'], entity: P_access)])
class Alcool{

  final int? id;
  final String day;
  final String type;
  final int quantity; 
  final int hour;
  final double? volume;
  final double? percentage;

  Alcool(this.id, this.day,this.type, this.quantity, this.hour, this.volume, this.percentage);
  
}