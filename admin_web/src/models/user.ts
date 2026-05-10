export class User {
  id: string;
  fullName: string;
  email: string;
  role: 'student' | 'teacher' | 'admin';
  createdAt: string;

  constructor(
    id: string,
    fullName: string,
    email: string,
    role: 'student' | 'teacher' | 'admin',
    createdAt: string
  ) {
    this.id = id;
    this.fullName = fullName;
    this.email = email;
    this.role = role;
    this.createdAt = createdAt;
  }

  toMap(): any {
    return {
      id: this.id,
      full_name: this.fullName,
      email: this.email,
      role: this.role,
      created_at: this.createdAt, 
    };
  }

  //  Used only on INSERT — omits id (comes from auth) and created_at (DB default)
  toInsertMap(): any {
    return {
      id: this.id,       // must include auth UUID
      full_name: this.fullName,
      email: this.email,
      role: this.role,
    };
  }

  static fromMap(map: any): User {
    return new User(
      map.id,
      map.full_name,
      map.email,
      map.role,
      map.created_at ? new Date(map.created_at).toLocaleString() : ""
    );
  }
}