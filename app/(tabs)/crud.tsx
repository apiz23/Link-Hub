import { StyleSheet, Switch } from "react-native";
import { Text, View } from "@/components/Themed";
import { Button, Form, Input, Label, Sheet, Spinner, XStack } from "tamagui";
import { useEffect, useState } from "react";
import { AntDesign } from "@expo/vector-icons";
import { ChevronDown } from "@tamagui/lucide-icons";
import { useColorScheme } from "@/components/useColorScheme";
import { supabase } from "@/lib/supabase";

export default function Crud() {
	const colorScheme = useColorScheme();

	const iconColor = colorScheme === "dark" ? "white" : "black";
	const [open, setOpen] = useState(false);
	const [modal, setModal] = useState(true);
	const [status, setStatus] = useState<"off" | "submitting" | "submitted">(
		"off"
	);

	const [name, setName] = useState("");
	const [url, setUrl] = useState("");

	useEffect(() => {
		if (status === "submitting") {
			const timer = setTimeout(() => setStatus("off"), 2000);
			return () => {
				clearTimeout(timer);
			};
		}
	}, [status]);

	const handleAdd = async () => {
		setStatus("submitting");

		const { data, error } = await supabase
			.from("link_hub")
			.insert([{ name, url }])
			.select();

		if (error) {
			console.error("Error inserting data:", error);
			setStatus("off");
			return;
		}

		console.log("Data inserted successfully:", data);
		setStatus("submitted");
		setName("");
		setUrl("");
		setOpen(false);
	};

	return (
		<View style={styles.container}>
			<Button onPress={() => setOpen(true)}>
				<AntDesign name="addfile" size={24} color={iconColor} />
			</Button>
			<Sheet
				modal={modal}
				open={open}
				onOpenChange={setOpen}
				snapPoints={undefined}
				dismissOnSnapToBottom
				animation="medium"
			>
				<Sheet.Overlay />
				<Sheet.Handle />
				<Sheet.Frame
					padding="$4"
					justifyContent="center"
					alignItems="center"
					backgroundColor="#fff"
				>
					<Button
						circular
						icon={ChevronDown}
						onPress={() => setOpen(false)}
						marginVertical="$4"
					/>
					<View
						style={{
							height: "90%",
							width: "100%",
							backgroundColor: "transparent",
							padding: 20,
						}}
					>
						<Form onSubmit={handleAdd} backgroundColor="$colorTransparent">
							<Label width={90} htmlFor="name" color="black">
								Name
							</Label>
							<Input id="name" value={name} onChangeText={(text) => setName(text)} />
							<Label width={90} htmlFor="url" color="black">
								Url
							</Label>
							<Input id="url" value={url} onChangeText={(text) => setUrl(text)} />
							<Form.Trigger asChild disabled={status !== "off"}>
								<Button
									icon={status === "submitting" ? () => <Spinner /> : undefined}
									style={styles.btnSubmit}
								>
									Submit
								</Button>
							</Form.Trigger>
						</Form>
					</View>
				</Sheet.Frame>
			</Sheet>
		</View>
	);
}

const styles = StyleSheet.create({
	container: {
		padding: 20,
		paddingTop: 50,
		flex: 1,
		width: "100%",
	},
	title: {
		paddingTop: 40,
		fontSize: 20,
		fontWeight: "bold",
	},
	separator: {
		marginVertical: 30,
		height: 1,
		width: "100%",
	},
	btnSubmit: {
		marginTop: 10,
		maxWidth: 150,
	},
});
