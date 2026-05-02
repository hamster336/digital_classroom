export class Teacher {
  id: string;
  employeeId: string;
  subjectIds: string[];
  classIds: string[];

  constructor(
    id: string,
    employeeId: string,
    subjectIds: string[],
    classIds: string[]
  ) {
    this.id =id;
    this.employeeId = employeeId;
    this.subjectIds = subjectIds;
    this.classIds = classIds;
  }

  static fromMap(map: any): Teacher {
    return new Teacher(
      map.id,
      map.employee_id,
      map.subject_ids || [],
      map.class_ids || []
    );
  }

  toMap() {
    return {
      id: this.id,
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
    };
  }

  toInsertMap() {
    return {
      id: this.id,
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
    };
  }
}