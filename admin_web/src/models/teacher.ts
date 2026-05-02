export class Teacher {
  id: string | null;
  employeeId: string;
  subjectIds: string[];
  classIds: string[];
  avatarPath: string | null;
  lastCheckedNotices: Date | null;

  constructor(
    id: string | null,
    employeeId: string,
    subjectIds: string[],
    classIds: string[],
    avatarPath: string | null,
    lastCheckedNotices: Date | null
  ) {
    this.id = id;
    this.employeeId = employeeId;
    this.subjectIds = subjectIds;
    this.classIds = classIds;
    this.avatarPath = avatarPath;
    this.lastCheckedNotices = lastCheckedNotices;
  }

  /** DB → App */
  static fromMap(map: any): Teacher {
    return new Teacher(
      map.id ?? null,
      map.employee_id ?? "",
      map.subject_ids ?? [],
      map.class_ids ?? [],
      map.avatar_path ?? null,
      map.last_checked_notices
        ? new Date(map.last_checked_notices)
        : null
    );
  }

  /** App → DB */
  toMap() {
    return {
      ...(this.id && { id: this.id }),
      employee_id: this.employeeId,
      subject_ids: this.subjectIds,
      class_ids: this.classIds,
      avatar_path: this.avatarPath,
      last_checked_notices: this.lastCheckedNotices
        ? this.lastCheckedNotices.toISOString()
        : null,
    };
  }
}