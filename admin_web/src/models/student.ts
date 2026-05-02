export class Student {
  id: string | null;
  rollNo: number;
  subjectIds: string[];
  avatarUrl: string | null;
  classId: string;
  lastCheckedNotices: Date | null;  

  constructor(
    id: string | null,
    rollNo: number,
    subjectIds: string[],
    avatarUrl: string | null,
    classId: string,
    lastCheckedNotices: Date | null 
  ) {
    this.id = id;
    this.rollNo = rollNo;
    this.subjectIds = subjectIds;
    this.avatarUrl = avatarUrl;
    this.classId = classId;
    this.lastCheckedNotices = lastCheckedNotices;
  }

  // Convert API response to Student object
  static fromMap(map: any): Student {
    return new Student(
      map.id ?? null,
      map.roll_no,
      map.subject_ids ?? [],        
      map.avatar_url ?? null,
      map.class_id,
      map.last_checked_notices      
        ? new Date(map.last_checked_notices)
        : null
    );
  }

  // Convert Student object to API
  toMap() {
    return {
      id: this.id,
      roll_no: this.rollNo,
      subject_ids: this.subjectIds,
      avatar_url: this.avatarUrl,
      class_id: this.classId,
      last_checked_notices: this.lastCheckedNotices     
        ? this.lastCheckedNotices.toISOString()
        : null,
    };
  }
}