class TaskModel{

String? task;
bool? isComplete;

TaskModel({this.task,this.isComplete});

factory TaskModel.fromJson(Map taskmap){
  return TaskModel(
    task: taskmap["task"],
    isComplete: taskmap["isComplete"]
  );
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['task'] = this.task;
  data['isComplete'] = this.isComplete;
  return data;
}


}