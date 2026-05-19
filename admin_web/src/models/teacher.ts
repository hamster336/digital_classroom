export class Teacher {
  id: string;
  fullName: string;
  email: string;
  employeeId: string;
  subjectIds: string[];
  classIds: string[];
  avatarPath: string | null;

  constructor(
    id: string,
    fullName: string,
    email: string,
    employeeId: string,
    subjectIds: string[],
    classIds: string[],
    avatarPath: string | null
  ) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.employeeId = employeeId;
    this.subjectIds = subjectIds;
    this.classIds = classIds;
    this.avatarPath = avatarPath;
  }

  static fromMap(map: any): Teacher {
    return new Teacher(
      map.id,
      map.full_name || map.fullName || "",  // from users JOIN or memory
      map.email || "",                       // from users JOIN or memory
      map.employee_id || "",
      map.subject_ids || [],
      map.class_ids || [],
      map.avatar_path || null
    );
  }

  toMap() {
    return {
      id: this.id,
      // full_name and email live in users table — NOT in teacher table
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
      avatar_path: this.avatarPath,
    };
  }

  toInsertMap() {
    return {
      id: this.id,
      // full_name and email live in users table — NOT in teacher table
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
      avatar_path: this.avatarPath,
    };
  }
}