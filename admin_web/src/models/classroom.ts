export class Classroom {
  id: string | null;
  name: string;
  createdAt: Date;
  faculty: string;
  startYear: number;
  endYear: number;
  isActive: boolean; 
  constructor(
    id: string | null,
    name: string,
    createdAt: Date,
    faculty: string,
    startYear: number,
    endYear: number,
    isActive: boolean
  ) {
    this.id = id;
    this.name = name;
    this.createdAt = createdAt;
    this.faculty = faculty;
    this.startYear = startYear;
    this.endYear = endYear;
    this.isActive = isActive;
  }

  static fromMap(map: any): Classroom {
    return new Classroom(
      map.id,
      map.name,
      new Date(map.created_at),
      map.faculty,
      map.start_year,
      map.end_year,
      map.is_active   
    );
  }

  toMap() {
    return {
      id: this.id,
      name: this.name,
      created_at: this.createdAt.toISOString(),
      faculty: this.faculty,
      start_year: this.startYear,
      end_year: this.endYear,
      is_active: this.isActive,  
    };
  }
}