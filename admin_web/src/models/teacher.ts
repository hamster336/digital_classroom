export class Teacher {
  id: string;
  fullName: string;
  employeeId: string;
  subjectIds: string[];
  classIds: string[];

  constructor(
    id: string,
    fullName: string,
    employeeId: string,
    subjectIds: string[],
    classIds: string[]
  ) {
    this.id =id;
    this.fullName= fullName;
    this.employeeId = employeeId;
    this.subjectIds = subjectIds;
    this.classIds = classIds;
  }

  static fromMap(map: any): Teacher {
    return new Teacher(
      map.id,
      map.full_name,
      map.employee_id,
      map.subject_ids || [],
      map.class_ids || []
    );
  }

  toMap() {
    return {
      id: this.id,
      full_name: this.fullName,
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
    };
  }

  // toInsertMap() {
  //   return {
  //     id: this.id,
  //     full_name: this.fullName,
  //     employee_id: this.employeeId,
  //     subject_ids: this.subjectIds,
  //     class_ids: this.classIds,
  //   };
  // }
}