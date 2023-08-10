import { registerDecorator, ValidationOptions } from 'class-validator';

export const IsUserId = (validationOptions?: ValidationOptions) => {
	return (object: object, propertyName: string) => {
		registerDecorator({
			name: 'isUserId',
			target: object.constructor,
			propertyName: propertyName,
			options: validationOptions,
			validator: {
				validate(value: any) {
					return typeof value === 'string' && /^user_[a-zA-Z0-9]+$/.test(value);
				},
			},
		});
	};
};
