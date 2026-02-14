export interface Assignment {
  id: string;
  user_id: string;
  assignment_role: 'nurse' | 'physician';
  profile_id: string;
  ward_id: string;
  created_at: string;
  updated_at: string;
}

export type CreateAssignmentInput = Omit<Assignment, 'id' | 'created_at' | 'updated_at'>;
export type UpdateAssignmentInput = Partial<CreateAssignmentInput>;
