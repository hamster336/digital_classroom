export class Teacher {
  id: string | null;
  employeeId: string;       
  subjectIds: string[];     
  classIds: string[];       
  avatarUrl: string | null; 
  lastCheckedNotices: Date | null;  

  constructor(
    id: string | null,
    employeeId: string,
    subjectIds: string[],
    classIds: string[],
    avatarUrl: string | null,
    lastCheckedNotices: Date | null  
  ) {
    this.id = id;
    this.employeeId = employeeId;
    this.subjectIds = subjectIds;
    this.classIds = classIds;
    this.avatarUrl = avatarUrl;
    this.lastCheckedNotices = lastCheckedNotices;
  }

  // DB (UTC) → Teacher object (Local)
  static fromMap(map: any): Teacher {
    return new Teacher(
      map.id ?? null,
      map.employee_id,
      map.subject_ids ?? [],
      map.class_ids ?? [],
      map.avatar_url ?? null,
      map.last_checked_notices
        ? new Date(map.last_checked_notices)  //  UTC → Local
        : null
    );
  }

  // Teacher object (Local) → DB (UTC)
  toMap() {
    return {
      id:                   this.id,
      employee_id:          this.employeeId,
      subject_ids:          this.subjectIds,
      class_ids:            this.classIds,
      avatar_url:           this.avatarUrl,
      last_checked_notices: this.lastCheckedNotices
        ? this.lastCheckedNotices.toISOString()  //  Local → UTC
        : null,
    };
  }
}