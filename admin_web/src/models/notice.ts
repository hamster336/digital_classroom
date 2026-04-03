
export class Notice {
  id: string | null;
  title: string;
  publishedAt: Date;
  scheduledAt: Date | null;
  description: string;
  priority: string;

  constructor(
    id: string |null,
    title: string,
    publishedAt: Date,
    scheduledAt: Date | null,
    description: string,
    priority: string
  ) {
    this.id = id;
    this.title = title;
    this.publishedAt = publishedAt;
    this.scheduledAt = scheduledAt;
    this.description = description;
    this.priority = priority;
  }

  // Convert API response to Notice object
  static fromMap(map: any): Notice {
    return new Notice(
      map.id,
      map.title,
      new Date(map.published_at),
      map.scheduled_at ? new Date(map.scheduled_at) : null,
      map.description,
      map.priority
    );
  }

  // Convert Notice object to API 
  toMap() {
    return {
      id: this.id,
      title: this.title,
      published_at: this.publishedAt.toISOString(),
      scheduled_at: this.scheduledAt
        ? this.scheduledAt.toISOString()
        : null,
      description: this.description,
      priority: this.priority,
    };
  }
}