import { useState } from 'react';
import { Plus } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { useAssignments } from '@/hooks/use-assignments';
import { AssignmentForm } from '@/components/assignment-form';
import { AssignmentList } from '@/components/assignment-list';
import type { CreateAssignmentInput } from '@/types/assignment';

export default function AssignmentsPage() {
  const { items, loading, create, remove } = useAssignments();
  const [showForm, setShowForm] = useState(false);

  const handleCreate = async (data: CreateAssignmentInput) => {
    await create(data);
    setShowForm(false);
  };

  return (
    <div className="container mx-auto max-w-4xl py-8 px-4">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-3xl font-bold">Assignments</h1>
        <Button onClick={() => setShowForm(!showForm)}><Plus className="h-4 w-4 mr-2" />Add Assignment</Button>
      </div>
      {showForm && (
        <div className="mb-8 p-6 border rounded-[var(--radius)]">
          <h2 className="text-lg font-semibold mb-4">New Assignment</h2>
          <AssignmentForm onSubmit={handleCreate} onCancel={() => setShowForm(false)} />
        </div>
      )}
      {loading ? (
        <div className="flex justify-center py-12"><div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[hsl(var(--primary))]" /></div>
      ) : (
        <AssignmentList items={items} onDelete={remove} />
      )}
    </div>
  );
}
