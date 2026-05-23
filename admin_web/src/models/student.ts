export class Student {
  id: string;
  fullName: string;
  rollNumber: string;
  subjectIds: string[];
  avatarPath: string | null;
  classId: string;
  lastCheckedNotices: Date | null;

  constructor(
    id: string,
    fullName: string,
    rollNumber: string,
    subjectIds: string[],
    avatarPath: string | null,
    classId: string,
    lastCheckedNotices: Date | null
  ) {
    this.id = id;
    this.fullName = fullName;
    this.rollNumber = rollNumber;
    this.subjectIds = subjectIds;
    this.avatarPath = avatarPath;
    this.classId = classId;
    this.lastCheckedNotices = lastCheckedNotices;
  }

  static fromMap(map: any): Student {
    return new Student(
      map.id,
      map.full_name || map.fullName || "",  // from users JOIN or memory
      map.roll_number,
      map.subject_ids || [],
      map.avatar_path,
      map.class_id,
      map.last_checked_notices ? new Date(map.last_checked_notices) : null
    );
  }

  //  Full map including id (used for updates/reads)
  toMap() {
    return {
      id: this.id,
      // full_name lives in users table — NOT in student table
      roll_number: this.rollNumber,
      subject_ids: this.subjectIds,
      avatar_path: this.avatarPath,
      class_id: this.classId,
      last_checked_notices: this.lastCheckedNotices
        ? this.lastCheckedNotices.toISOString()
        : null,
    };
  }

  //  Used only on INSERT — omits id so Supabase generates UUID
  toInsertMap() {
    return {
      id: this.id,
      // full_name lives in users table — NOT in student table
      roll_number: this.rollNumber,
      subject_ids: this.subjectIds,
      avatar_path: this.avatarPath,
      class_id: this.classId,
      last_checked_notices: this.lastCheckedNotices
        ? this.lastCheckedNotices.toISOString()
        : new Date().toISOString(),
    };
  }
}
