import { supabase } from "@/lib/supabase";

export interface Link {
	id: string;
	name: string;
	url: string;
	created_at: string;
}
export const fetchLinks = async () => {
	try {
		const { data: linkHub, error } = await supabase.from("link_hub").select("*");

		if (error) {
			console.error("Error fetching links:", error.message);
			return;
		}

		if (linkHub && linkHub.length > 0) {
			return linkHub;
		}
	} catch (error: any) {
		console.error("Error fetching links:", error.message);
	}
};

export const deleteLink = async (id: number) => {
	try {
		const { error } = await supabase.from("link_hub").delete().eq("id", id);
		if (error) {
			console.error("Error fetching links:", error.message);
			return;
		}
		return {
			success: true,
		};
	} catch (error: any) {
		console.error("Error delete link", error.message);
	}
};
