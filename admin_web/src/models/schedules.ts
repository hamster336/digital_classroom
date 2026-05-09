export class Schedule {
    id: string;
    name: string;
    classId: string;
    filePath: string;
    createdAt: string;

    constructor(
        id: string,
        name: string,
        classId: string,
        filePath: string,
        createdAt: string
    ) {
        this.id = id;
        this.name = name;
        this.classId = classId;
        this.filePath = filePath;
        this.createdAt = createdAt;
    }

    static fromMap(map: any): Schedule {
        return new Schedule(
            map.id,
            map.name,
            map.class_id,
            map.file_path,
            map.created_at
        );
    }

    toInsertMap() {
        return {
            name: this.name,
            class_id: this.classId,
            file_path: this.filePath,
        };
    }
}