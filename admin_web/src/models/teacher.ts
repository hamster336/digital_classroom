export class Teacher {
  id: string;
  fullName: string;
  email: string;
  employeeId: string;
  subjectIds: string[];
  classIds: string[];
  avatarPath: string | null;  // ✅ added

  constructor(
    id: string,
    fullName: string,
    email: string,
    employeeId: string,
    subjectIds: string[],
    classIds: string[],
    avatarPath: string | null   // ✅ added
  ) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.employeeId = employeeId;
    this.subjectIds = subjectIds;
    this.classIds = classIds;
    this.avatarPath = avatarPath;  // ✅ added
  }

static fromMap(map: any): Teacher {
  return new Teacher(
    map.id,
    map.fullName || '',
    map.email || '',
    map.employeeId,
    map.subjectIds || [],
    map.classIds || [],
    map.avatarPath || null
  );
}
  toMap() {
    return {
      id: this.id,
      full_name: this.fullName,      // ✅ added
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
      avatar_path: this.avatarPath,  // ✅ added
    };
  }

  toInsertMap() {
    return {
      id: this.id,
      full_name: this.fullName,      // ✅ added
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
      avatar_path: this.avatarPath,  // ✅ added
    };
  }
}