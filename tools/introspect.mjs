import { buildClientSchema, getIntrospectionQuery, printSchema } from "graphql";
import fs from "node:fs";

async function main() {
	const introspectionQuery = getIntrospectionQuery();
	console.log(introspectionQuery);

	// const response = await fetch(process.argv[2] ?? process.env.ENDPOINT, {
	// 	method: "POST",
	// 	headers: {
	// 		"Content-Type": "application/json",
	// 		Authorization: `Bearer ${process.env.AUTH_TOKEN}`,
	// 	},
	// 	body: JSON.stringify({ query: introspectionQuery }),
	// });

	// const { data } = await response.json();

	// const schema = buildClientSchema(data);

	// if (process.argv[3]) {
	// 	const outputFile = new URL(process.argv[3], import.meta.url);
	// 	console.info("writing to:", outputFile.toString());
	// 	await fs.promises.writeFile(outputFile, printSchema(schema));
	// } else {
	// 	console.log(printSchema(schema));
	// }
}

main();
