import { registerDecorator, ValidationOptions } from 'class-validator';

export const IsAtlasSchema = (validationOptions?: ValidationOptions) => {
	return (object: object, propertyName: string) => {
		registerDecorator({
			name: 'isAtlasSchema',
			target: object.constructor,
			propertyName: propertyName,
			options: validationOptions,
			validator: {
				validate(value: any) {
					return (
						!!value &&
						typeof value === 'object' &&
						'version' in value &&
						/^\d$/.test(value.version) &&
						'data' in value &&
						Array.isArray(value.data)
						// 	TODO: Validate entire schema
					);
				},
			},
		});
	};
};
