require("react-native-url-polyfill/auto");
import AsyncStorage from "@react-native-async-storage/async-storage";
import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://ykzglhnkmwqyekcvutgx.supabase.co";
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlremdsaG5rbXdxeWVrY3Z1dGd4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA1NjYzNTIsImV4cCI6MjAyNjE0MjM1Mn0.qO5klTaA07a2cb9QL0G6osMhBWG1n1t34CH2yhxXyLQ';

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
	throw new Error("Supabase URL or Supabase Anon Key is missing");
}

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
	auth: {
		storage: AsyncStorage,
		autoRefreshToken: true,
		persistSession: true,
		detectSessionInUrl: false,
	},
});
