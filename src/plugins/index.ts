// Ref: https://the-guild.dev/graphql/mesh/docs/plugins/plugins-introduction

import { Plugin } from "@envelop/core";
import {
	ResolveUserFn,
	ValidateUserFn,
	useGenericAuth,
} from "@envelop/generic-auth";

type UserType = {
	id: string;
};
const resolveUserFn: ResolveUserFn<UserType> = async (context) => {
	/* ... */
	// TODO: https://the-guild.dev/graphql/envelop/plugins/use-generic-auth
	return { id: "1" };
};
const validateUser: ValidateUserFn<UserType> = (params) => {
	/* ... */
	// console.debug("user:", params.user);
};
const plugins: Plugin[] = [
	useGenericAuth({
		resolveUserFn,
		validateUser,
		mode: "protect-all",
	}),
	// ... other plugins ...
];

export default plugins;
