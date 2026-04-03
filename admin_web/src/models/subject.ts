export class Subject {
  id: string |null;
  name: string;
  classId: string;
  teacherId: string;

  constructor(
    id: string |null,
    name: string,
    classId: string,
    teacherId: string
  ) {
    this.id = id;
    this.name = name;
    this.classId = classId;
    this.teacherId = teacherId;
  }

  // Convert API response to Subject object
  static fromMap(map: any): Subject {
    return new Subject(
      map.id ?? null,
      map.name,
      map.class_id,
      map.teacher_id
    );
  }

  // Convert Subject object to API
  toMap() {
    return {
      id: this.id,
      name: this.name,
      class_id: this.classId,
      teacher_id: this.teacherId,
    };
  }
}