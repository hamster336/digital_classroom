// Day type for validation
export type DayOfWeek =
  | "Monday"
  | "Tuesday"
  | "Wednesday"
  | "Thursday"
  | "Friday"
  | "Saturday"
  | "Sunday";

export class Schedule {
  id: string | null;
  classId: string;
  subjectId: string;
  dayOfWeek: DayOfWeek;   // strict type
  startTime: string;       // format: "HH:mm" e.g "09:00"
  endTime: string;         

  constructor(
    id: string | null,
    classId: string,
    subjectId: string,
    dayOfWeek: DayOfWeek,
    startTime: string,
    endTime: string
  ) {
   
    // validation moved to controller
    this.id = id;
    this.classId = classId;
    this.subjectId = subjectId;
    this.dayOfWeek = dayOfWeek;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  // DB → Schedule object
  static fromMap(map: any): Schedule {
    return new Schedule(
      map.id ?? null,          
      map.class_id,
      map.subject_id,
      map.day_of_week as DayOfWeek,
      map.start_time,
      map.end_time
    );
  }

  // Schedule object → DB
  toMap() {
    return {
      id:          this.id,
      class_id:    this.classId,
      subject_id:  this.subjectId,
      day_of_week: this.dayOfWeek,
      start_time:  this.startTime,
      end_time:    this.endTime,
    };
  }
}